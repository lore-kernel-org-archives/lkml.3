Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbbAGD5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:57:36 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:1656 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbbAGD5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 22:57:34 -0500
Message-ID: <54ACAE9A.1000701@huawei.com>
Date: Wed, 7 Jan 2015 11:57:14 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 cgroup/for-3.20] cgroup: add dummy css_put() for !CONFIG_CGROUPS
References: <20150106165720.GI3077@htj.dyndns.org> <20150106165815.GJ3077@htj.dyndns.org>
In-Reply-To: <20150106165815.GJ3077@htj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.54ACAEDE.015A,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: bcf0d94f5295ff702786c6b516055642
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/7 0:58, Tejun Heo wrote:
> This will later be depended upon by the scheduled cgroup writeback
> support.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Zefan Li <lizefan@huawei.com>

