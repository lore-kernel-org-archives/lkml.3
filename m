Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaIXRdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:33:05 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:65487 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaIXRdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:33:03 -0400
Date: Wed, 24 Sep 2014 13:32:58 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: kmo@daterainc.com, axboe@kernel.dk, hch@infradead.org, hannes@cmpxchg.org
Subject: Re: [PATCHSET percpu/for-3.18] percpu_ref: implement
 switch_to_atomic/percpu()
Message-ID: <20140924173258.GB29067@mtj.dyndns.org>
References: <1411451718-17807-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411451718-17807-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 01:55:09AM -0400, Tejun Heo wrote:
>  0001-percpu_ref-relocate-percpu_ref_reinit.patch
>  0002-percpu_ref-minor-code-and-comment-updates.patch
>  0003-percpu_ref-replace-pcpu_-prefix-with-percpu_.patch
>  0004-percpu_ref-rename-things-to-prepare-for-decoupling-p.patch
>  0005-percpu_ref-add-PCPU_REF_DEAD.patch
>  0006-percpu_ref-decouple-switching-to-atomic-mode-and-kil.patch
>  0007-percpu_ref-decouple-switching-to-percpu-mode-and-rei.patch
>  0008-percpu_ref-add-PERCPU_REF_INIT_-flags.patch
>  0009-percpu_ref-make-INIT_ATOMIC-and-switch_to_atomic-sti.patch

Applied 1-9 to percpu/for-3.18.

Thanks.

-- 
tejun
