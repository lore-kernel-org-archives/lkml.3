Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3G2Dvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 23:51:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16855 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3G2Dvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 23:51:37 -0400
Message-ID: <51F5E5A1.4010108@huawei.com>
Date: Mon, 29 Jul 2013 11:46:41 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
CC: <tj@kernel.org>, <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpuset: get rid of the useless forward declaration
 of cpuset
References: <51F34501.1090608@huawei.com>
In-Reply-To: <51F34501.1090608@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/27 11:56, Zhao Hongjiang wrote:
> get rid of the useless forward declaration of the struct cpuset cause the 
> below define it.
> 
> Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>

Acked-by: Li Zefan <lizefan@huawei.com>

