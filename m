Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaEUEZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:25:28 -0400
Received: from fencepost.gnu.org ([208.118.235.10]:44748 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaEUEZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:25:26 -0400
From: David Kastrup <dak@gnu.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v2.0.0-rc4
References: <xmqqr43oq8q5.fsf@gitster.dls.corp.google.com>
	<537bf50f27417_353e13c330846@nysa.notmuch>
Date: Wed, 21 May 2014 06:25:24 +0200
In-Reply-To: <537bf50f27417_353e13c330846@nysa.notmuch> (Felipe Contreras's
	message of "Tue, 20 May 2014 19:36:31 -0500")
Message-ID: <87tx8jahcb.fsf@fencepost.gnu.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Contreras <felipe.contreras@gmail.com> writes:

> Junio C Hamano wrote:
>
>>  * The remote-helper interface to fast-import/fast-export via the
>>    transport-helper has been tightened to avoid leaving the import
>>    marks file from a failed/crashed run, as such a file that is out-of-
>>    sync with reality confuses a later invocation of itself.
>
> Really? Where are the patches for that?

The following seems related:

commit 10e1feebb454d99eb6644cc53b94255f40e6fe9c
Author: Junio C Hamano <gitster@pobox.com>
Date:   Wed May 14 12:06:35 2014 -0700

    Revert "Merge branch 'fc/transport-helper-sync-error-fix'"
    
    This reverts commit d508e4a8e2391ae2596403b6478d01cf3d5f928f,
    reversing changes made to e42552135a2a396f37053a89f44952ea907870b2.
    
    The author of the original topic says he broke the upcoming 2.0
    release with something that relates to "synchronization crash
    regression" while refusing to give further specifics, so this would
    unfortunately be the safest option for the upcoming release.
    
    Signed-off-by: Junio C Hamano <gitster@pobox.com>


-- 
David Kastrup
