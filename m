Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbaEPQaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:30:24 -0400
Received: from plane.gmane.org ([80.91.229.3]:60368 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434AbaEPQaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:30:22 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: 3.14.4 Kernel BUG at fs/namei.c : KDE's kate + ecryptfs + BTRFS
 + LVM2 + LUKS
Date: Fri, 16 May 2014 20:16:41 +0530
Organization: RESEARCHUT
Message-ID: <hvkh4b-r3n.ln1@news.researchut.com>
References: <1496827.xlXt6pDnuG@zafu>
Reply-To: rrs@researchut.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 27.7.162.194
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
In-Reply-To: <1496827.xlXt6pDnuG@zafu>
Cc: linux-btrfs@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/16/2014 06:36 PM, Swâmi Petaramesh wrote:
> Underlying is ecryptfs over BTRFS over LVM2 over LUKS (what else ?)

I recently switched one of my drives to BTRFS because I wanted
transparent compression. Since I also needed encryption, I chose:

BTRFS => LUKS (Device Mapper) => SCSI Block.

Is there any value having LVM2 and ecryptfs in the way you have stacked
? Just curious.

-- 
Given the large number of mailing lists I follow, I request you to CC me
in replies for quicker response

