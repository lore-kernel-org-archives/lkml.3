Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaATQK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:10:59 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36506 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbaATQK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:10:56 -0500
MIME-Version: 1.0
Date: Mon, 20 Jan 2014 21:40:56 +0530
Message-ID: <CAH9_wRPJaCXixCuTDOepvn107jfLST9jgF14iXAb-QPtphHWsQ@mail.gmail.com>
Subject: mutex ownership tracking
From: Sriram V <vshrirama@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

What is the importance of ownership tracking of mutex? Why is it
mandatory that the task which
locked must unlock it to escape lockdep.


-- 
Regards,
Sriram
