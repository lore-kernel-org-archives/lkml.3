Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3GXSiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:38:05 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:58213 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751222Ab3GXSiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:38:02 -0400
Message-ID: <51F01F04.5030201@hurleysoftware.com>
Date: Wed, 24 Jul 2013 14:37:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>, Borislav Petkov <bp@alien8.de>
CC: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        Doug Thompson <dougthompson@xmission.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep warning in edac_create_sysfs_mci_device
References: <20130721144819.GJ24717@sanechka.spb.ru> <20130721190212.GA31470@pd.tnic> <CA+8MBb+GzRkj9M7gy9g5CvXfzMGCYXRXfTUycbojnspyrwvTeQ@mail.gmail.com>
In-Reply-To: <CA+8MBb+GzRkj9M7gy9g5CvXfzMGCYXRXfTUycbojnspyrwvTeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 12:27 PM, Tony Luck wrote:
> On Sun, Jul 21, 2013 at 12:02 PM, Borislav Petkov <bp@alien8.de> wrote:
>> A fix is on the way:
>>
>> http://marc.info/?l=linux-edac&m=137422971614927&w=2
>
> Fix was pulled into Linus' tree yesterday evening (Portland, OR timezone):
>
> commit 88d84ac97378c2f1d5fec9af1e8b7d9a662d6b00
> Author: Borislav Petkov <bp@suse.de>
> Date:   Fri Jul 19 12:28:25 2013 +0200
>
>      EDAC: Fix lockdep splat
>
> Alexandra: Give it a test and let me and Boris know if you still see
> any problems.

Thanks for fixing this. Now I can fix the lockdep splat I just
introduced to linux-next :(

Regards,
Peter Hurley

