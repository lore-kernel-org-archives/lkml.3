Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3CUCLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 22:11:54 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:38587 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3CUCLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 22:11:53 -0400
MIME-Version: 1.0
From: Drunkard Zhang <gongfan193@gmail.com>
Date: Thu, 21 Mar 2013 10:11:33 +0800
Message-ID: <CAJiejCS+pNfMb4eGGEFkCYP3DpP+VYeq08_ZxhyChTFbS08bGA@mail.gmail.com>
Subject: 'ip route show cache' shown nothing
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that the behavior of 'ip route show cache' changed in recent
version of iproute2 with recent kernel, it shown nothing now, but it
still exists in 'man ip-route'.

Is this function dropped now? How could I find out routing cache or
FIB in recent kernel?

Thanks.
