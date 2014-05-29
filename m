Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416AbaE2R4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:56:37 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35277 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965204AbaE2Rxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:53:38 -0400
MIME-Version: 1.0
Date: Thu, 29 May 2014 13:53:37 -0400
Message-ID: <CALRD3qKzmrvRqBabQQuvVH7jTb0mexZGw4rXVTBkYS3YRc6NtQ@mail.gmail.com>
Subject: dev over nfs
From: riya khanna <riyakhanna1983@gmail.com>
To: undisclosed-recipients:;
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to access remote devices locally by mounting/exporting /dev
nodes over NFS. However, looks like the access requests are treated local
based on major minor numbers (e.g. "cat /mnt-dev-over-nfs/kmg" output is
same as "cat /dev/kmsg")

How can I change this behavior? and if it is at all feasible?

Thanks,
Riya
