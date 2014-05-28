Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbaE1WoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:44:07 -0400
Received: from smtp.pobox.com ([208.72.237.35]:50114 "EHLO smtp.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778AbaE1WoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:44:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=e5d9txEmd1lM7nLkIDmQszwhrrhJ+Zkv
	qdiukBYXqQHBHnrZ0JQRore7dr9+1wk9Fci6dnGjVz8roAn6XqWl52G/dXYmBbWq
	6dymhfm1jaADb6gM18Qkm/QRcD+d/mA3CAZ2qSkWgiaMPQq/sYw6KPe5Mo29l2cY
	2Mjwp8ae6hA=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v2.0.0
References: <xmqqr43dbkni.fsf@gitster.dls.corp.google.com>
Date: Wed, 28 May 2014 15:43:16 -0700
In-Reply-To: <xmqqr43dbkni.fsf@gitster.dls.corp.google.com> (Junio C. Hamano's
	message of "Wed, 28 May 2014 15:31:13 -0700")
Message-ID: <xmqqmwe1bk3f.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 76792B8C-E6B9-11E3-BBB7-9903E9FBB39C-77302942!pb-smtp0.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> The tarballs are found at:
>
>     https://www.kernel.org/pub/software/scm/git/testing/

Heh, I do not know how this slipped in, but the real release tarball
is not in git/testing/ but found at:

     https://www.kernel.org/pub/software/scm/git/

