Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaAQRnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:43:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58183 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbaAQRnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:43:19 -0500
Message-ID: <52D96B9D.703@zytor.com>
Date: Fri, 17 Jan 2014 09:42:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Kim Naru <kim.naru@amd.com>, Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
References: <20140114115547.GA29887@pd.tnic> <52D55468.6000000@zytor.com> <20140114153534.GE29865@pd.tnic> <20140114162722.GF29865@pd.tnic> <52D59ACC.3090100@amd.com> <20140114203848.GP29865@pd.tnic> <52D81DB5.7000608@amd.com> <20140117002123.GA9165@khazad-dum.debian.net> <20140117101842.GB8715@pd.tnic> <52D958FC.9020700@zytor.com> <20140117170213.GG8715@pd.tnic>
In-Reply-To: <20140117170213.GG8715@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 09:02 AM, Borislav Petkov wrote:
> 
> No, you don't. :-)
> 
> You would much prefer to have the workaround done in the BIOS and only
> if there's a coverage hole, only then to do it in the kernel.
> 

Hence the question: did an unfixed BIOS ever make it into a shipping
production system?  Because if it did, we do have a coverage hole.

	-hpa

