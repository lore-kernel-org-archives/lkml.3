Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3GIHf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:35:26 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33826 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3GIHfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:35:25 -0400
Message-ID: <51DBBD3A.3020200@free-electrons.com>
Date: Tue, 09 Jul 2013 09:35:22 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Woodhouse, David" <David.Woodhouse@intel.com>,
        artem.bityutskiy@linux.intel.com, Cris <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 0/3] cris: cleanup Kconfig files
References: <1373263451-26841-1-git-send-email-michael.opdenacker@free-electrons.com> <CAMuHMdVm_G6GuMnROosQb94rk3fokiOaz70T-HZ79amV3Cyx4A@mail.gmail.com>
In-Reply-To: <CAMuHMdVm_G6GuMnROosQb94rk3fokiOaz70T-HZ79amV3Cyx4A@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 07/09/2013 09:33 AM, Geert Uytterhoeven wrote:
> Hi Michael,
>
> On Mon, Jul 8, 2013 at 8:04 AM, Michael Opdenacker
> <michael.opdenacker@free-electrons.com> wrote:
>> This set of patches removes kernel configuration parameters for the
>> CRIS architecture, which are used nowhere in the kernel source
>> code and makefiles.
>>
>> Michael Opdenacker (3):
>>   cris: cleanup arch-v10/drivers/Kconfig
>>   cris: cleanup arch-v32/drivers/Kconfig
>>   cris: cleanup Kconfig
>>
>>  arch/cris/Kconfig                  |   9 --
>>  arch/cris/arch-v10/drivers/Kconfig |  79 ---------------
>>  arch/cris/arch-v32/drivers/Kconfig | 197 -------------------------------------
>>  3 files changed, 285 deletions(-)
> (At least) Some of these have been in cris/for-next for a few months,
> courtesy of
> Paul Bolle.

Thank you for your reply. I hope they will make it this time.

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

