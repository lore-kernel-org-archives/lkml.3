Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3JRLEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:04:53 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47080 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3JRLEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:04:51 -0400
Message-ID: <526115AE.3040405@linux.vnet.ibm.com>
Date: Fri, 18 Oct 2013 16:34:14 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Chen Gong <gong.chen@linux.intel.com>
CC: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com> <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com> <20131015165435.GA2777@naverao1-tp.ibm.com> <20131016095030.GA8954@gchen.bj.intel.com> <20131016104904.GD13608@pd.tnic>
In-Reply-To: <20131016104904.GD13608@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101811-6102-0000-0000-0000045CD861
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 04:19 PM, Borislav Petkov wrote:
> Btw, I don't know what's the problem but when I hit reply-to-all to your
> emails, mutt drops your email address from the To: and makes the CC:
> list become the To: list. Strange.

I'm seeing the same thing. Looking at the headers, Chen Gong's email 
includes a Mail-Follow-Up field which could be the problem.

- Naveen

