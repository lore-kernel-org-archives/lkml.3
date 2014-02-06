Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaBFO5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:57:30 -0500
Received: from mail-la0-f65.google.com ([209.85.215.65]:46624 "EHLO
	mail-la0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaBFO52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:57:28 -0500
MIME-Version: 1.0
Date: Thu, 6 Feb 2014 20:27:27 +0530
Message-ID: <CAKVd3pXVF_kXc6=kAsRb43bYdGOLhVGvSS-QoMDCiXYqxJi0fw@mail.gmail.com>
Subject: Inode entry of a process in /proc/pid changes
From: navin p <navinp1281@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
        I am running RHEL 6.4 on  2.6 linux x64 on one of our customer server.
When there is a stress or the server is highly loaded by one of the backup
agents the inode number (got from ls -i /proc/<pid> or ls -i
/proc/<pid>/task/<tid> ) changes. If you don't put any stress/load on the
system , the inode number remains intact.
 I have a few questions for troubleshooting this problem .

1) Can /proc be mounted so that the inode numbers of a process and its
tasks (threads) don't changed unless it is a new process ?

2) How is the proc file system created /freed  and subentries under it?

3)Why do the inode numbers change. I understand for a newly created process
it could have a new inode number but for a long running process like init
why does it change ever ?

Can someone point out source links to the latest kernel version so that i
can understand it better ?

Thank you,
Navin Parakkal
