Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3HFFqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:46:07 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50847 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3HFFqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:46:04 -0400
Message-ID: <52008D8F.6090905@linux.vnet.ibm.com>
Date: Tue, 06 Aug 2013 13:45:51 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] perf kvm live - latest round take 4
References: <1375753297-69645-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1375753297-69645-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080605-6102-0000-0000-000003F97F81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 09:41 AM, David Ahern wrote:
> Hi Arnaldo:
> 
> This round addresses all of Xiao's comments. It also includes a small
> change in the live mode introduction to improve ordered samples
> processing. For that a change in perf-session functions is needed.

Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

David, could you please update the documentation? It can be a separate
patch.

