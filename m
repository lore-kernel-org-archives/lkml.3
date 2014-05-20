Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaETGBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:01:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:51947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaETGBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 02:01:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,871,1392192000"; 
   d="scan'208";a="434329355"
Message-ID: <537AEF2D.9040207@intel.com>
Date: Tue, 20 May 2014 13:59:09 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [x86, vdso] cfda7bb9ecb: +14.7% will-it-scale.per_thread_ops
Content-Type: multipart/mixed;
 boundary="------------020702050100050902030205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020702050100050902030205
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andy,

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
commit cfda7bb9ecbf9d96264bb5bade33a842966d1062 ("x86, vdso: Move syscall and sysenter setup into kernel/cpu/common.c")

test case: nhm4/will-it-scale/sched_yield

3d7ee969bffcc98  cfda7bb9ecbf9d96264bb5bad
---------------  -------------------------
     5497021 ~ 0%     +14.7%    6303424 ~ 0%  TOTAL will-it-scale.per_thread_ops
        0.54 ~ 0%      +5.6%       0.57 ~ 0%  TOTAL will-it-scale.scalability
     6209483 ~ 0%      +1.6%    6305917 ~ 0%  TOTAL will-it-scale.per_process_ops
        2455 ~ 5%     +16.9%       2870 ~ 5%  TOTAL cpuidle.C1-NHM.usage
        8829 ~ 7%     +15.2%      10169 ~10%  TOTAL slabinfo.kmalloc-64.active_objs
       24.13 ~12%     +48.9%      35.93 ~14%  TOTAL time.user_time
         393 ~ 0%      -3.0%        382 ~ 1%  TOTAL time.system_time


Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


Thanks,
Jet



--------------020702050100050902030205
Content-Type: text/plain; charset=UTF-8;
 name="reproduce"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="reproduce"

ZWNobyBwZXJmb3JtYW5jZSA+IC9zeXMvZGV2aWNlcy9zeXN0ZW0vY3B1L2NwdTAvY3B1ZnJl
cS9zY2FsaW5nX2dvdmVybm9yCmVjaG8gcGVyZm9ybWFuY2UgPiAvc3lzL2RldmljZXMvc3lz
dGVtL2NwdS9jcHUxL2NwdWZyZXEvc2NhbGluZ19nb3Zlcm5vcgplY2hvIHBlcmZvcm1hbmNl
ID4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1Mi9jcHVmcmVxL3NjYWxpbmdfZ292ZXJu
b3IKZWNobyBwZXJmb3JtYW5jZSA+IC9zeXMvZGV2aWNlcy9zeXN0ZW0vY3B1L2NwdTMvY3B1
ZnJlcS9zY2FsaW5nX2dvdmVybm9yCmVjaG8gcGVyZm9ybWFuY2UgPiAvc3lzL2RldmljZXMv
c3lzdGVtL2NwdS9jcHU0L2NwdWZyZXEvc2NhbGluZ19nb3Zlcm5vcgplY2hvIHBlcmZvcm1h
bmNlID4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1NS9jcHVmcmVxL3NjYWxpbmdfZ292
ZXJub3IKZWNobyBwZXJmb3JtYW5jZSA+IC9zeXMvZGV2aWNlcy9zeXN0ZW0vY3B1L2NwdTYv
Y3B1ZnJlcS9zY2FsaW5nX2dvdmVybm9yCmVjaG8gcGVyZm9ybWFuY2UgPiAvc3lzL2Rldmlj
ZXMvc3lzdGVtL2NwdS9jcHU3L2NwdWZyZXEvc2NhbGluZ19nb3Zlcm5vcgouL3J1bnRlc3Qu
cHkgc2NoZWRfeWllbGQgMzIgMSA0IDYgOAoKCg==
--------------020702050100050902030205--
