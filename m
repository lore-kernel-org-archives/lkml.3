Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbaJUQKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:10:55 -0400
Received: from mout.gmx.net ([212.227.17.21]:58325 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663AbaJUQKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:10:54 -0400
Message-ID: <5446858B.3040107@gmx.de>
Date: Tue, 21 Oct 2014 18:10:51 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: virtualization@lists.linux-foundation.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: v3.18-rc1 32 bit KVM hangs early in boot process
References: <5445479C.4030201@gmx.de>
In-Reply-To: <5445479C.4030201@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:ylcJVI2Smrpfgr9Lrc/w85NDfyDn2/Xq4uJwp0u2nlcntzSlz4+
 3n9u2WOX5C+TOZZudlu1ZNz+kC6S2oP42SoeN3wTS9+liULpye6s417Wc20WDeG28lDQbEl
 nnKPhdDXg/GgAhb+AJnNvARsZ8DcceTlo2Wt2KTxvbFfGnDxVfIiykNCqC4FiaGZHijQnKg
 IepChPqEKFac1X2werhXQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 07:34 PM, Toralf Förster wrote:
> I uploaded the screen shots from the virt-manager to [1] and [2]
> 
> FWIW e56d9fccb was fine so the bug slipped in after that.
> 

> 
> [1] http://www.directupload.net/file/d/3781/j9mwrtpq_jpg.htm
> [2] http://www.directupload.net/file/d/3781/29trc56v_jpg.htm
> 
It might be virtio-console related, when the uevetns are processed:

http://www.directupload.net/file/d/3782/6lg5yihh_jpg.htm

-- 
Toralf
pgp key: 0076 E94E

