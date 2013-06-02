Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3FBFJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 01:09:12 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:36191 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3FBFJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 01:09:06 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <51AAD326.4040809@wwwdotorg.org>
References: <1369626821-28494-1-git-send-email-acourbot@nvidia.com>
	<51A42ED5.2060104@wwwdotorg.org>
	<20130601051223.GB5189@quad.lixom.net>
	<51AAD326.4040809@wwwdotorg.org>
Date: Sat, 1 Jun 2013 22:09:04 -0700
Message-ID: <CAOesGMi=f=2S9y96-DtBzOZydhsJ1pF+m26AzdQjj59qtQu-oA@mail.gmail.com>
Subject: Re: [PATCH v2] video: simplefb: add mode parsing function
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Clark <robclark@gmail.com>,
        linux-fbdev@vger.kernel.org,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rpi-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 10:07 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/31/2013 11:12 PM, Olof Johansson wrote:
>> On Mon, May 27, 2013 at 10:13:09PM -0600, Stephen Warren wrote:
>>> On 05/26/2013 09:53 PM, Alexandre Courbot wrote:
>>>> The naming scheme of simplefb's mode is precise enough to allow building
>>>> the mode structure from it instead of using a static list of modes. This
>>>> patch introduces a function that does this. In case exotic modes that
>>>> cannot be represented from their name alone are needed, the static list
>>>> of modes is still available as a backup.
> ...
>>> As such, we should either:
>>>
>>> a) Just add new entries into the format array that already exists in the
>>> driver. Given David's response, this might be simplest.
>>
>> I think so too. Is this even needed? Do we have any users of the newer formats
>> or is it just someone trying to feature-creep this driver to make the "simple"
>> part of the name inaccurate? :)
>
> Alex is working on board support for a new NVIDIA board, where IIRC the
> bootloader sets up some 32-bit ARGB format for the panel.

Ah, ok. Let's just implement that one format too then. :)


-Olof
