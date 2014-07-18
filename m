Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbaGRD1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:27:36 -0400
Received: from tundra.namei.org ([65.99.196.166]:33976 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759599AbaGRD1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:27:34 -0400
Date: Fri, 18 Jul 2014 13:26:48 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        David Drysdale <drysdale@google.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v12 11/11] seccomp: add thread sync ability
In-Reply-To: <1405620518-18495-1-git-send-email-keescook@chromium.org>
Message-ID: <alpine.LRH.2.11.1407181325200.15709@namei.org>
References: <1405620518-18495-1-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Kees Cook wrote:

> Twelfth time's the charm! :)

Btw, there doesn't seem to be an official seccomp maintainer.  Kees, would 
you like to volunteer for this?  If so, send in a patch for MAINTAINERS, 
and set up a git tree for me to pull from.



-- 
James Morris
<jmorris@namei.org>

