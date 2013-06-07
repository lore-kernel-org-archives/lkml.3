Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3FGOyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:54:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40852 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab3FGOyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:54:50 -0400
MIME-Version: 1.0
In-Reply-To: <s5hmwr2qwwh.wl%tiwai@suse.de>
References: <1370520110-32293-1-git-send-email-ming.lei@canonical.com>
	<1370520110-32293-5-git-send-email-ming.lei@canonical.com>
	<20130606194847.GB4526@kroah.com>
	<CACVXFVPtLHCNhuybkgUiHEYEcaB6BdCZs6M7QLHHsNdMfCtzug@mail.gmail.com>
	<s5hmwr2qwwh.wl%tiwai@suse.de>
Date: Fri, 7 Jun 2013 22:54:47 +0800
Message-ID: <CACVXFVPMLqXr-9OFQqSBi9rKhN2475fw_LND1Tt+fx4cTrqBfA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 4/4] firmware loader: don't allow to request
 firmware via relative path
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 2:04 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 7 Jun 2013 09:30:09 +0800,
> Ming Lei wrote:
>>
>> On Fri, Jun 7, 2013 at 3:48 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Thu, Jun 06, 2013 at 08:01:50PM +0800, Ming Lei wrote:
>> >> It isn't a good pratice to request firmware via relative path, also
>> >> might have security issue, so don't do it.
>> >
>> > What would the security issue be?  You are letting the person who build
>> > the kernel specify this, so they can put whatever they want in here, a
>> > '..' isn't going to keep them from being able to do "bad" things if they
>> > really want to.
>>
>> In VM case, guest kernel might access host filesystem files via this trick,
>> but not sure if it is possible.
>>
>> Takashi, could you explain the security issue of relative path?
>
> Well, I don't know, too.  My original question was what happens if you
> pass a relative path to firmware_class.fw_path_para module option
> (or the new kconfig)...

OK, so please ignore the patch.

Thanks
--
Ming Lei
