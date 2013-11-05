Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3KERCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:02:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34843 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3KERCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:02:00 -0500
Message-ID: <52792477.207@kernel.dk>
Date: Tue, 05 Nov 2013 10:01:43 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Block window closed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The block merge will be a bigger one than usual this round, with the
additon of both blk-mq and the immutable bio_vecs. Even with the
semi-extended window, I will now close of any pulls to the core or
driver bits unless they are fixes to previous code.

I will still collect fixes for the 3.13 window, but they will be going
into the for-linus branch (as usual) for later inclusion after the merge
window closes.

-- 
Jens Axboe

