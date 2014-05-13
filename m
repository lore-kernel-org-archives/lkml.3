Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaEMWcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:32:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaEMWcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:32:47 -0400
Date: Wed, 14 May 2014 00:32:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: YongHwan Ki <kyhw@afoi.co.kr>
cc: rydberg@euromail.se, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH] Add VID/PID for HID-type Multi-Touch Module of AFO CO.,
  LTD.
In-Reply-To: <003a01cf488c$ab9c4400$02d4cc00$@afoi.co.kr>
Message-ID: <alpine.LNX.2.00.1405140030270.16459@pobox.suse.cz>
References: <006101cf4812$c3ac1680$4b044380$@afoi.co.kr> <alpine.LNX.2.00.1403251156260.17500@pobox.suse.cz> <003a01cf488c$ab9c4400$02d4cc00$@afoi.co.kr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014, YongHwan Ki wrote:

> Sorry, I woud like to add the AFO defines in the Linux Kernel.
> No afo defines exists in the current kernel tree.
> I correctly changed the log for adding the afo defines.
> 
> Kernel Version : linux-3.14.rc7
> Signed-off-by: Yonghwan Ki <kyhw@afoi.co.kr>

Sorry, but this patch is broken again.

It contains the PRIVATE RSA KEY stuff and 'dontdiff' stuff again.

I can create the patch myself and add your signoff / Reported-by (please 
let me know if you want me to do that), but it's crucial for you to fix 
your workflow for any next submission.

Especially the private key disclosure should probably better be avoided :)

-- 
Jiri Kosina
SUSE Labs
