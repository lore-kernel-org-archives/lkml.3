Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaIIH1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:27:41 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49932 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaIIH1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:27:40 -0400
MIME-Version: 1.0
Date: Tue, 9 Sep 2014 15:27:38 +0800
Message-ID: <CANPB7a68M5vpddT9my4hb8LPoQj=sPLi7cdDXi36xo6uZNES=Q@mail.gmail.com>
Subject: How to remove a tasklet_struct from tasklet_vec?
From: jingguo yao <yaojingguo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tasklet_kill clears TASKLET_STATE_SCHED bit. tasklet_action reconstructs
the tasklet_vec with TASKLET_STATE_SCHED bit cleared.  But it does not
remove any tasklet_struct from tasklet_vec. tasklet_kill_immediate can
remove a tasklet_struct form tasklet_vec. But it can only run when CPU
state is CPU_DEAD. Is there any other way to remove tasklet_struct from
tasklet_vec?

-- 
Jingguo
