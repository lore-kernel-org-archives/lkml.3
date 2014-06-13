Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbaFMRZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:25:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50779 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbaFMRZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:25:15 -0400
Message-ID: <539B33E1.7040500@zytor.com>
Date: Fri, 13 Jun 2014 10:24:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v3] x86,vdso: Fix vdso_install
References: <CA+5PVA5rP4cF14-ckD4K4MgBNtfHB+xPg3whEL26JkxegE7qpg@mail.gmail.com>	<b10299edd8ba98d17e07dafcd895b8ecf4d99eff.1402586707.git.luto@amacapital.net> <CA+5PVA49T_hygP2O_ykqCpg6GFiJDds37LgroKvAfLSm0mkBKA@mail.gmail.com>
In-Reply-To: <CA+5PVA49T_hygP2O_ykqCpg6GFiJDds37LgroKvAfLSm0mkBKA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 10:01 AM, Josh Boyer wrote:
> On Thu, Jun 12, 2014 at 11:28 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> The filenames are different now.  Inspired by a patch from
>> Sam Ravnborg.
>>
>> Acked-by: Sam Ravnborg <sam@ravnborg.org>
>> Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> 
> Things look great with this version.  Thanks much!
> 
> Tested-by: Josh Boyer <jwboyer@fedoraproject.org>
> 

Are we okay with the 64-bit vdso now being installed as vdso64.so?

	-hpa


