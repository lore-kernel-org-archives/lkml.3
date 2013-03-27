Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3C0U3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 16:29:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58446 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab3C0U3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 16:29:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tzmqof4Rzec_2bVm+UxH86Zas6JhgizfzHNfnvrsvhoYA@mail.gmail.com>
References: <kg69ef$vdb$1@ger.gmane.org> <CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com>
 <5126C3E1.80801@gmail.com> <513BACAC.9050800@gmail.com> <CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
 <20130319195950.GA16828@srcf.ucam.org> <CA+55aFy9nbc+9VyCg0BA9E85sRwksQXvu6Wqgurf5omv2mPtZw@mail.gmail.com>
 <5148D5C8.2000701@gmail.com> <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
 <20130325235525.GA3423@srcf.ucam.org> <CAErSpo7iUsV4ca0vhs085_prsTXBEvuTnuw1O_NUr-CvUytYGQ@mail.gmail.com>
 <CAPM=9tzmqof4Rzec_2bVm+UxH86Zas6JhgizfzHNfnvrsvhoYA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 27 Mar 2013 14:28:55 -0600
Message-ID: <CAErSpo5X_KiDPh36J91P2Ux_RHJ6TNcJ+JPAOkP=JaNt+Rag5w@mail.gmail.com>
Subject: Re: Regression: Screen turns off when booting in EFI mode
To: Dave Airlie <airlied@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Skeggs <skeggsb@gmail.com>, bugzilla <bugzilla@colorremedies.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 2:02 PM, Dave Airlie <airlied@gmail.com> wrote:
>>
>> That RedHat bugzilla is from kernel-3.9.0-0.rc4.git0.1.fc19.x86_64.
>> Does that kernel include Matthew's patch from Mar 19?  I'm wondering
>> if that report is for the same problem Mantas saw and possibly would
>> be *fixed* by the Mar 19 patch, or if it is for a problem with the Mar
>> 19 patch itself.
>>
>> I would check this myself, but I don't know how to figure out what's
>> in kernel-3.9.0-0.rc4.git0.1.fc19.x86_64.
>
> Its 3.9-rc4 + a git snapshot one day after,
>
> From what I can see 3.9-rc4 contains this patch from Mar 19.

Yep, looks like it to me, too.  Apparently the Mar 19 patch
(547b52463) worked for Mantas but not for Chris.

So I'll wait for testing reports from Mantas and Chris before pushing
the Mar 26 patches.  Linus can take them earlier if he wants, of
course :)

Bjorn
