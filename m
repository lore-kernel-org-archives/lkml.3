Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976AbaJaO14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:27:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578AbaJaO1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:27:54 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] block: Fix computation of merged request priority
In-Reply-To: <1414698218-11199-1-git-send-email-jack@suse.cz> (Jan Kara's
	message of "Thu, 30 Oct 2014 20:43:38 +0100")
References: <1414698218-11199-1-git-send-email-jack@suse.cz>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 31 Oct 2014 10:27:50 -0400
Message-ID: <x49ioj0e2l5.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> Priority of a merged request is computed by ioprio_best(). If one of the
> requests has undefined priority (IOPRIO_CLASS_NONE) and another request
> has priority from IOPRIO_CLASS_BE, the function will return the
> undefined priority which is wrong. Fix the function to properly return
> priority of a request with the defined priority.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
