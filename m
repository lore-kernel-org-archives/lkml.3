Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbaLPJj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:39:57 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:9445 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaLPJjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:39:54 -0500
Message-ID: <548FFDDC.5090001@huawei.com>
Date: Tue, 16 Dec 2014 17:39:40 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <wangnan0@huawei.com>
Subject: The kernel interface of inotify was removed ?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A010203.548FFDE8.01B5,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 207d7e07ae8f863721e0bf012ad4ba38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	I try to use inotify in kernel module according to Documentation/filesystems/inotify.txt,
	but i found inotify was reimplemented in this commit 63c882a (inotify: reimplement inotify using fsnotify)
	and the document has been expired.

	Now how we can monitor file in kernel module ?

	Best regards!

