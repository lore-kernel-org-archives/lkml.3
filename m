Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab3ILIOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:14:01 -0400
Received: from gw1.transmode.se ([195.58.98.146]:59025 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943Ab3ILIN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:13:59 -0400
In-Reply-To: <201309111550.r8BFoS4G015798@localhost.localdomain>
References: <201309111550.r8BFoS4G015798@localhost.localdomain>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>
MIME-Version: 1.0
Subject: Re: [PATCH] powerpc 8xx: Reverting commit
 e0908085fc2391c85b85fb814ae1df377c8e0dcb which has become useless
X-KeepSent: CD99DF58:8FB3071C-C1257BE4:002D04C9;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OFCD99DF58.8FB3071C-ONC1257BE4.002D04C9-C1257BE4.002D38F4@transmode.se>
Date: Thu, 12 Sep 2013 10:13:56 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 12/09/2013 10:13:56,
	Serialize complete at 12/09/2013 10:13:56
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Leroy <christophe.leroy@c-s.fr> wrote on 2013/09/11 17:50:28:

> From: Christophe Leroy <christophe.leroy@c-s.fr>
> To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras 
<paulus@samba.org>, 
> Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, Joakim 
Tjernlund <joakim.tjernlund@transmode.se>
> Date: 2013/09/11 18:43
> Subject: [PATCH] powerpc 8xx: Reverting commit 
e0908085fc2391c85b85fb814ae1df377c8e0dcb which has become useless
> 
> The commit e0908085fc2391c85b85fb814ae1df377c8e0dcb is not needed 
anymore.
> The issue was because dcbst wrongly sets the store bit when causing a 
DTLB
> error, but this is now fixed by commit 
0a2ab51ffb8dfdf51402dcfb446629648c96bc78
> which handles the buggy dcbx instructions on data page faults on the 
8xx.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

 Jocke
