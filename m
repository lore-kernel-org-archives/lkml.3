Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaAICXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 21:23:09 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:40132 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaAICXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 21:23:07 -0500
Date: Wed, 8 Jan 2014 18:23:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, mpm@selenic.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: Fix possible format string bug.
In-Reply-To: <201401041632.ACE65688.JSVQtFFMHOOOLF@I-love.SAKURA.ne.jp>
Message-ID: <alpine.DEB.2.02.1401081822350.15616@chino.kir.corp.google.com>
References: <201401041632.ACE65688.JSVQtFFMHOOOLF@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Jan 2014, Tetsuo Handa wrote:

> The "name" is determined at runtime and is parsed as format string.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Acked-by: David Rientjes <rientjes@google.com>
