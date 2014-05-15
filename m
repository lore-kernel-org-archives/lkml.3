Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaEOObt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:31:49 -0400
Received: from smtp1.ono.com ([62.42.230.162]:3807 "EHLO smtp1.ono.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbaEOObs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:31:48 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2014 10:31:47 EDT
X-CTCH-RefID: str=0001.0A0B0207.5374CE6C.002B,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-VOD: Unknown
X-CTCH-Spam: Unknown
Message-ID: <5374CE6B.6030905@ono.com>
Date: Thu, 15 May 2014 16:25:47 +0200
From: =?UTF-8?B?SkEgTWFnYWxsw7Nu?= <jamagallon@ono.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: NFSACL broken from 3.13 to 3.14
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry if this gets twice to the list, my ISP's SMPT seems to have
gone haywire....)

Hi...

I mount homes from a Solaris 10 server, via NFSv3. Solaris nfs has a special
sideband server on a port for NFS to check ACLs. With previous version of
kernel (3.13.10 was the latest I check), I need no special option to mount
Solaris shares. With 3.14, it began to give errors, directories created
with mkdir returned error, files got created but truncated to 0 size...
(now I have 3.14.3).

I solved it adding the 'noacl' option to Solaris mount entries in autofs,
so the linux clients don't use the sideband protocol.

As I have read, NFSACL usage is negotitated between client and server.
Something has changed and the negotiation fails, perhaps ?

Any idea ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>        \               Winter is coming...
