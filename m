Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaAMJsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:48:36 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:47764 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaAMJse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:48:34 -0500
Message-ID: <1389606503.1585.11.camel@localhost.localdomain>
Subject: Re: [PATCH 2/2] perf tools: add .gitignore for files generated for
 feature check
From: Yann Droneaud <ydroneaud@opteya.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
Date: Mon, 13 Jan 2014 10:48:23 +0100
In-Reply-To: <faf3b2dfbe992bc3d088c1420a6721a6b7c2019d.1389461371.git.ydroneaud@opteya.com>
References: <cover.1389461371.git.ydroneaud@opteya.com>
	 <faf3b2dfbe992bc3d088c1420a6721a6b7c2019d.1389461371.git.ydroneaud@opteya.com>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le samedi 11 janvier 2014 à 18:48 +0100, Yann Droneaud a écrit :
> As part of system features auto-detection, some dependency files are
> generated and some programs are built.
> 
> These files should not be considered by git, so this patch adds
> a dedicated .gitignore in tools/perf/config/ sub-directory to
> ignore the files.
> 
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>

Please ignore this patch, a .gitignore is now present in linux-next
(from tag next-20140113).

Regards.

-- 
Yann Droneaud
OPTEYA


