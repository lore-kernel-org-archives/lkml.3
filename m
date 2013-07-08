Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3GHSXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:23:50 -0400
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:55041 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751874Ab3GHSXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <651e35493f6a970610d35785e1972ec9e2426abf.1372777600.git.ydroneaud@opteya.com>
References: <cover.1372777600.git.ydroneaud@opteya.com> <651e35493f6a970610d35785e1972ec9e2426abf.1372777600.git.ydroneaud@opteya.com>
From: Roland Dreier <roland@purestorage.com>
Date: Mon, 8 Jul 2013 11:23:26 -0700
Message-ID: <CAL1RGDXV1_BjSLrQDFdVQ1_D75+bMtOtikHOUp8VBiy_OJUf=w@mail.gmail.com>
Subject: Re: [PATCH 03/13] infiniband: use get_unused_fd_flags(0) instead of get_unused_fd()
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I just applied a patch to convert to
get_unused_fd_flags(O_CLOEXEC) in uverbs, since there isn't anything
useful that can be done with uverbs fds across an exec.

 - R.
