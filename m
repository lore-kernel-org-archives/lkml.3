Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab3FEXBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:01:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41726 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129Ab3FEXBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:01:47 -0400
Message-ID: <51AFC335.3000902@zytor.com>
Date: Wed, 05 Jun 2013 16:01:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <herrmann.der.user@googlemail.com>
Subject: Re: [PATCH 0/2] x86/microcode/amd: early loading fixes
References: <1370463236-2115-1-git-send-email-jacob.shin@amd.com> <20130605221833.GA15427@pd.tnic>
In-Reply-To: <20130605221833.GA15427@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 03:18 PM, Borislav Petkov wrote:
> On Wed, Jun 05, 2013 at 03:13:54PM -0500, Jacob Shin wrote:
>> This patchset addreses two problems with early loading on AMD.
> 
> It would be nice if, in the future, you put the maintainers of this
> driver to CC.
> 
> Unless you're volunteering up for maintaining it...
> 

Indeed.  My bad for not adding all in, too.

	-hpa

