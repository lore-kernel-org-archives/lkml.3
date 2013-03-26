Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3CZVkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:40:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:54115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3CZVkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:40:07 -0400
Message-ID: <515207AF.8070808@infradead.org>
Date: Tue, 26 Mar 2013 13:40:15 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: linux-next: Tree for Mar 26 (snd/soc/codecs)
References: <20130326174214.27b644d00421bae4c8d3cf3b@canb.auug.org.au>
In-Reply-To: <20130326174214.27b644d00421bae4c8d3cf3b@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/13 23:42, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130325:
> 


on i386:

sound/built-in.o:(.rodata+0xeb9d0): undefined reference to `arizona_rate_text'
sound/built-in.o:(.rodata+0xeb9d4): undefined reference to `arizona_rate_val'
sound/built-in.o:(.rodata+0xeb9e8): undefined reference to `arizona_rate_text'
sound/built-in.o:(.rodata+0xeb9ec): undefined reference to `arizona_rate_val'
sound/built-in.o:(.rodata+0xeba00): undefined reference to `arizona_rate_text'
sound/built-in.o:(.rodata+0xeba04): undefined reference to `arizona_rate_val'
sound/built-in.o:(.rodata+0xeba18): undefined reference to `arizona_rate_text'
sound/built-in.o:(.rodata+0xeba1c): undefined reference to `arizona_rate_val'


CONFIG_SND_SOC_WM_ADSP=y
but CONFIG_SND_SOC_ARIZONA is not enabled.





-- 
~Randy
