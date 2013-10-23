Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3JWArq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 20:47:46 -0400
Received: from mail-vc0-f195.google.com ([209.85.220.195]:49896 "EHLO
	mail-vc0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3JWArp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 20:47:45 -0400
MIME-Version: 1.0
Date: Wed, 23 Oct 2013 08:47:44 +0800
Message-ID: <CAK2Ky6xH9rvmpqQ31bi1QrC=dvt9T_8+ELHUZf_MFZccV6MiAw@mail.gmail.com>
Subject: A thought about IO scheduler in linux kernel for SSD
From: =?GB2312?B?uqvA2g==?= <bonben1989@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays,the IO schedulers in linux kernel have four types:

deadline,noop,Anticiptory and CFQ.CFQ is the default scheduler.But CFQ is

not a good scheduler for SSD,dealine may be a good choice.
When deadline runs,it has a mount of computation about merging and

sorting.Merge has three types: front_merge,no_merge and back_merge.
Why don't have  another type: merge based same sector.For example,it have

two bios in a request list,theyboth have the same bi->sector,the bi->size

maybe not equal. Whether can we put the latter bio replace the former?What

do you find that significant?Or the other levels in OS has finished this
function?
