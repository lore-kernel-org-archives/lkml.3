Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaKYAes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:34:48 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:37876 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750891AbaKYAer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:34:47 -0500
Message-ID: <5473CE5C.7010300@ubuntu.com>
Date: Mon, 24 Nov 2014 19:33:32 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Jason B. Akers" <jason.b.akers@intel.com>, linux-ide@vger.kernel.org
CC: kapil.karkra@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, dgilbert@interlog.com
Subject: Re: [RFC PATCH] sg3_utils: Added hybrid information log utility
References: <20141029195400.5225.96984.stgit@stg-AndroidDev-VirtualBox> <20141029195720.5225.51331.stgit@stg-AndroidDev-VirtualBox>
In-Reply-To: <20141029195720.5225.51331.stgit@stg-AndroidDev-VirtualBox>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 10/29/2014 03:57 PM, Jason B. Akers wrote:
> From: Kapil Karkra <kapil.karkra@intel.com>
> 
> A solid state hybrid drive (SSHD) is a hard drive with a small
> embedded NAND. Host drivers can manage this NAND using the commands
> defined by SATA 3.2 standard. One SATA command that provides
> visibility into the SSHD's cache behavior is get hybrid log
> command. This augmentation allows users to issue the command as
> follows:
> 
> sg_sat_get_hybrid_log /dev/sdc assuming /dev/sdc is an SSHD.
> 
> patch applies to the following sourcebase from where to clone: 
> https://github.com/hreinecke/sg3_utils.git

I cloned that repo and the patch does not apply cleanly.  git am -3
says the referenced blobs are not found and it has conflicts in
src/Makefile.am.  I manually fixed that up and then it fails to link
due to unresolved externals.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUc85UAAoJENRVrw2cjl5RR3YIAJOF0fcTkF5pM0OIA87hK8k8
ujwflBTy66ZbPzXMD97cTGYQ6gPp3UCeT/ZcElBfrGGAuD5u/ETXMJY7lqAZgYtK
bELPv6oLhz3ya2IO442sUlRYO4dVfwhsnak+2rLiQkXCy4WKSJ1EYiMIP/VHj8ne
5e8VYkuc0KamKjvT4v6EwJ7tM0blfJbYgmFGruIxOSgCAo94Zp9thAcctb9PbRex
HnPTcnw5cI1sCoLf5fJafhc9w/1H45WjJTnGF7zs4hq/GGsYCwryvI0ovwAzU9ST
R3jRvE+70oiyQDsj9EBak63hRYIAd8QzQ3TkCjaM5E1XHSU7vTnxvxAjKb4ZyF4=
=a8Vh
-----END PGP SIGNATURE-----
