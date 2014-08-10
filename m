Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaHJJBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 05:01:49 -0400
Received: from gw1.transmode.se ([195.58.98.146]:64031 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaHJJBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 05:01:48 -0400
References: <20140808070339.48C4D1ABCF0@localhost.localdomain>
In-Reply-To: <20140808070339.48C4D1ABCF0@localhost.localdomain>
Subject: Re: [PATCH 00/20] powerpc/8xx: Optimise MMU TLB handling and add support of
 16k pages
MIME-Version: 1.0
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Message-ID: <OF25844E90.2166CD88-ONC1257D30.00319859-C1257D30.0031986B@transmode.se>
Date: Sun, 10 Aug 2014 11:01:42 +0200
X-Mailer: Lotus Domino Web Server Release 8.5.3FP6 November 21, 2013
X-MIMETrack: Serialize by Notes Server on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 10/08/2014 11:01:42,
	Serialize complete at 10/08/2014 11:01:42,
	Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 10/08/2014 11:01:42
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
 This looks really cool! I am on vacation for one more week but I will have a closer
 look once I get back and things get back to normal.

  Jocke
 

 -----Christophe Leroy <christophe.leroy@c-s.fr> wrote: -----

 =======================
 To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>
 From: Christophe Leroy <christophe.leroy@c-s.fr>
 Date: 08/08/2014 9:04 
 Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, Joakim Tjernlund <joakim.tjernlund@transmode.se>, scottwood@freescale.com
 Subject: [PATCH 00/20] powerpc/8xx: Optimise MMU TLB handling and add support of 16k pages
 =======================
   This patchset:
* provides several MMU TLB handling optimisation on MPC8xx.
* adds support of 16k pages on MPC8xx.
All changes have been successfully tested on a custom board equipped with MPC885

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>
    
