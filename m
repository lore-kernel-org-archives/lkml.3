Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161801Ab3DEHZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 03:25:25 -0400
Received: from p-mail2.rd.francetelecom.com ([195.101.245.16]:49028 "EHLO
	p-mail2.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161688Ab3DEHZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 03:25:24 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Apr 2013 03:25:24 EDT
Message-ID: <515E7A86.4030909@Free.fr>
Date: Fri, 05 Apr 2013 09:17:26 +0200
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130315 Icedove/17.0.4
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: eric.valette@Free.fr, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Strange trace in dmesg on kernel 3.8.5
References: <515DD32F.3030509@free.fr> <20130404194404.GA8082@pd.tnic> <1365108338.3072.3.camel@shinybook.infradead.org> <515DCE6D.7080203@free.fr>
In-Reply-To: <515DCE6D.7080203@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Apr 2013 07:17:26.0584 (UTC) FILETIME=[A02F6380:01CE31CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 09:03 PM, Eric Valette wrote:

>> I fixed this already.
>>
>> https://git.kernel.org/cgit/linux/kernel/git/jgarzik/libata-dev.git/commit/?h=upstream-fixes&id=8e725c7f8a60feaa88edacd4dee2c754d5ae7706
>>
> Thanks for the support. I will apply the patch manually and wait for 3.8.6


Just to confirrm : fixed on my side with the patch.

Thanks again.

-- eric


