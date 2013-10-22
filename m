Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3JVNok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:44:40 -0400
Received: from mail-ve0-f196.google.com ([209.85.128.196]:61927 "EHLO
	mail-ve0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3JVNoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:44:38 -0400
MIME-Version: 1.0
Date: Tue, 22 Oct 2013 21:44:36 +0800
Message-ID: <CAK2Ky6wXP2PBW1Tc+sNvc5QrVYy6-ZkpFRrjPnyV_eb=PLhvcA@mail.gmail.com>
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
