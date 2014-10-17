Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaJQWoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 18:44:24 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:63411 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaJQWoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 18:44:23 -0400
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 17 Oct 2014 17:44:02 -0500
Message-ID: <CAH2r5mvBOJHLbRXHMt50E97_1E2Q8F_=PH9=u6N3yuuqSQVmDg@mail.gmail.com>
Subject: current mainline doesn't boot
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone know a workaround for the problem booting current mainline?
3.17 works fine for me, but recent mainline since 3.17 goes to a black
screen near the end of boot as X is about to start.

I also tried the Ubuntu build of the day (which also is based on
current mainline but with the Ubuntu config just in case it was some
driver issue) which fails the same way.



-- 
Thanks,

Steve
