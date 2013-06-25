Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3FYUIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:08:32 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40438 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3FYUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:08:31 -0400
Message-ID: <51C9F8B6.1010505@linux.vnet.ibm.com>
Date: Wed, 26 Jun 2013 01:38:22 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Chen Gong <gong.chen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/MCE: Update MCE severity condition check
References: <1371719773-27572-1-git-send-email-gong.chen@linux.intel.com> <20130625063257.GA2274@naverao1-tp.in.ibm.com> <3908561D78D1C84285E8C5FCA982C28F31C53805@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31C53805@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062520-5140-0000-0000-0000036DD1D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 10:01 PM, Luck, Tony wrote:
>> The SDM talks about "non-affected" logical processors, but perhaps we
>> can call this an "unaffected" thread?
>
> "unaffected" sounds a bit more natural (but close enough to the wording in
> the SDM that people should see the connection).

Yup - "unnatural" is precisely the term that describes my feeling when I 
read the original description :)

Thanks,
Naveen

