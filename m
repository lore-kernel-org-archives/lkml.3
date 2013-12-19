Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab3LSR2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:28:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab3LSR2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:28:09 -0500
Message-ID: <52B32C9E.7030209@redhat.com>
Date: Thu, 19 Dec 2013 12:27:58 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Greg Thelen <gthelen@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] ipc: change kern_ipc_perm.deleted type to bool
References: <2376eb01a06ca5e9ea68955f65ac1913929d41a1.1387416739.git.aquini@redhat.com>
In-Reply-To: <2376eb01a06ca5e9ea68955f65ac1913929d41a1.1387416739.git.aquini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 12:23 PM, Rafael Aquini wrote:
> struct kern_ipc_perm.deleted is meant to be used as a boolean toogle, and
> the changes introduced by this patch are just to make the case explicit.
>
> Signed-off-by: Rafael Aquini <aquini@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

