Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaFJTmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:42:18 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34160 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaFJTmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:42:15 -0400
MIME-Version: 1.0
X-Originating-IP: [80.196.35.44]
In-Reply-To: <5395D56C.4000304@fb.com>
References: <1402057225-7312-1-git-send-email-m@bjorling.me>
	<1402057225-7312-2-git-send-email-m@bjorling.me>
	<CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com>
	<5395BFF2.2080402@fb.com>
	<CACVXFVPGO9vsOv_uVa0+5AdBduu1RJ0Fmg8XPx1QgJAvnjKj_g@mail.gmail.com>
	<5395CE64.6040402@fb.com>
	<CACVXFVMQ_ehnsj=7+6-WmKLSQAhDRDvOEnE6Ekbwj8sfYuuRAA@mail.gmail.com>
	<5395D56C.4000304@fb.com>
Date: Tue, 10 Jun 2014 21:42:14 +0200
Message-ID: <CAOu_J6nkMAad-tkcnmxnkz1tOzG+nXfBv86neb7vEGVGkWu1cQ@mail.gmail.com>
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
From: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
To: Jens Axboe <axboe@fb.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I queued up a fix for it.
>

Rebased nvmemq_review on top of it. Thanks!
