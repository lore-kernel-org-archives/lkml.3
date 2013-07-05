Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab3GECBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 22:01:38 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36718 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab3GECBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 22:01:36 -0400
Message-ID: <51D628FD.2010806@igel.co.jp>
Date: Fri, 05 Jul 2013 11:01:33 +0900
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: lauraa@codeaurora.org
CC: Marek Szyprowski <m.szyprowski@samsung.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] fs/buffer.c: Revoke LRU when trying to drop buffers
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've come across a problem allocating chunks of CMA memory on a system
under heavy disk access load which seems very similar to the situation
described as the rationale for this patch:

https://lkml.org/lkml/2012/9/11/335

Basically buffer headers sitting on the LRU list preventing them from
being dropped during page migration.

I've tried the patch and it seems to solve my problems, so I'm wondering
if it is worth resubmitting. The discussion on the original thread seems
to have faded out. Does anyone know if it was continued somewhere else?

Thank you,
Damian
-- 
Damian Hobson-Garcia
IGEL Co.,Ltd
http://www.igel.co.jp
