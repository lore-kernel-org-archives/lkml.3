Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaEHDd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:33:26 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:49547 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaEHDdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:33:21 -0400
MIME-Version: 1.0
In-Reply-To: <1399518657.34016.23.camel@localhost>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
	<1399518657.34016.23.camel@localhost>
Date: Wed, 7 May 2014 20:33:20 -0700
Message-ID: <CAPcyv4g90avzU=d1t21vwY7dea4fAQWvMmZ5Z+tWmHAnFnuFyg@mail.gmail.com>
Subject: Re: [PATCH 0/8] Enable dma driver for MIC X100 Coprocessors.
From: Dan Williams <dan.j.williams@intel.com>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 8:10 PM, Sudeep Dutt <sudeep.dutt@intel.com> wrote:
> On Thu, 2014-04-24 at 11:10 -0700, Siva Krishna Yerramreddy wrote:
>> On Mon, 2014-04-14 at 13:14 -0700, Siva Yerramreddy wrote:
>> > I am sending all these patches to char-misc because there is a dependency
>> > between the patches for dma driver and other drivers.
>> >
>> Greg, any feedback on the patches?
>
> Hi Greg,
> The primary author of this patch series Siva is no longer with Intel so
> we will be taking ownership of addressing review feedback.
>
> The patches have been applied to the MIC GITHUB tree which is registered
> with Fengguang Wu's 0-day infrastructure and no issues have been
> reported.
>
> We have not received any feedback on the patches yet and were wondering
> if you had a chance to review them?

Fwiw, I'm still planning on reviewing these.
