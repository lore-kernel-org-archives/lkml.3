Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaEHWTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:19:53 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39943 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaEHWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:19:52 -0400
Message-ID: <536C0306.50202@gmail.com>
Date: Fri, 09 May 2014 00:19:50 +0200
From: =?UTF-8?B?SkEgTWFnYWxsw7Nu?= <jamagallonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: NFSACL broken from 3.13 to 3.14
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
J.A. Magallon <jamagallonn()gmail!com>     \               Winter is coming...
