Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3LQRy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 12:54:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55586 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab3LQRy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:54:57 -0500
Date: Tue, 17 Dec 2013 18:54:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers: ide: Include appropriate header file in
 ide-cd_verbose.c
Message-ID: <20131217175451.GI30592@pd.tnic>
References: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
 <20131217111920.GA30592@pd.tnic>
 <20131217164403.GD1062@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131217164403.GD1062@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 08:44:03AM -0800, Josh Triplett wrote:
> The two proposed patches here are extremely low risk, don't actually
> change the compiled code in any way like some of those did, and fix
> real compiler warnings.

Considering the fact that IDE is about to be deleted (unless something
embedded still wants it which I hardly doubt but hey, I'm always open to
surprises), putting *any* work into that is a complete waste of time,
IMO. But it is your time so I certainly won't tell you how to spend it.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
