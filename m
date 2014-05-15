Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaEOEGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:06:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:42895 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbaEOEG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:06:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1056,1389772800"; 
   d="scan'208";a="511921883"
Message-ID: <53743D42.3070309@intel.com>
Date: Thu, 15 May 2014 12:06:26 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [tracing] b1169cc69ba: +10060.4% proc-vmstat.numa_pte_updates
Content-Type: multipart/mixed;
 boundary="------------030205000807050707040800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030205000807050707040800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Steven,

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git ftrace/core
commit b1169cc69ba96b124df820904a6d3eb775491d7f ("tracing: Remove mock up poll wait function")

f4874261049e3ab  b1169cc69ba96b124df820904
---------------  -------------------------
       191 ~15%  +10060.4%      19487 ~ 8%  lkp-ne04/dd-write/1HDD-ext4-2dd.4k
       191 ~15%  +10060.4%      19487 ~ 8%  TOTAL proc-vmstat.numa_pte_updates

f4874261049e3ab  b1169cc69ba96b124df820904
---------------  -------------------------
   2419721 ~ 0%     +88.0%    4549654 ~ 2%  lkp-ws02/dd-write/11HDD-JBOD-cfq-xfs-1dd
   2419721 ~ 0%     +88.0%    4549654 ~ 2%  TOTAL perf-stat.context-switches

f4874261049e3ab  b1169cc69ba96b124df820904
---------------  -------------------------
       954 ~ 0%     +52.7%       1457 ~ 0%  lkp-ne04/dd-write/1HDD-ext4-2dd.4k
      3932 ~ 0%     +89.1%       7438 ~ 2%  lkp-ws02/dd-write/11HDD-JBOD-cfq-xfs-1dd
      4887 ~ 0%     +82.0%       8895 ~ 2%  TOTAL vmstat.system.cs

f4874261049e3ab  b1169cc69ba96b124df820904
---------------  -------------------------
    163477 ~ 0%     +60.1%     261769 ~ 0%  lkp-ws02/dd-write/11HDD-JBOD-cfq-xfs-1dd
    163477 ~ 0%     +60.1%     261769 ~ 0%  TOTAL perf-stat.cpu-migrations

f4874261049e3ab  b1169cc69ba96b124df820904
---------------  -------------------------
     28742 ~ 0%      +6.4%      30574 ~ 0%  lkp-ws02/dd-write/11HDD-JBOD-cfq-xfs-1dd
     28742 ~ 0%      +6.4%      30574 ~ 0%  TOTAL vmstat.system.in


Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent

	
Thanks,
Jet



--------------030205000807050707040800
Content-Type: text/plain; charset=UTF-8;
 name="reproduce"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="reproduce"

ZWNobyBwZXJmb3JtYW5jZSA+IC9zeXMvZGV2aWNlcy9zeXN0ZW0vY3B1L2NwdTAvY3B1ZnJl
cS9zY2FsaW5nX2dvdmVybm9yCmVjaG8gcGVyZm9ybWFuY2UgPiAvc3lzL2RldmljZXMvc3lz
dGVtL2NwdS9jcHUxL2NwdWZyZXEvc2NhbGluZ19nb3Zlcm5vcgplY2hvIHBlcmZvcm1hbmNl
ID4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1MTAvY3B1ZnJlcS9zY2FsaW5nX2dvdmVy
bm9yCmVjaG8gcGVyZm9ybWFuY2UgPiAvc3lzL2RldmljZXMvc3lzdGVtL2NwdS9jcHUxMS9j
cHVmcmVxL3NjYWxpbmdfZ292ZXJub3IKZWNobyBwZXJmb3JtYW5jZSA+IC9zeXMvZGV2aWNl
cy9zeXN0ZW0vY3B1L2NwdTEyL2NwdWZyZXEvc2NhbGluZ19nb3Zlcm5vcgplY2hvIHBlcmZv
cm1hbmNlID4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1MTMvY3B1ZnJlcS9zY2FsaW5n
X2dvdmVybm9yCmVjaG8gcGVyZm9ybWFuY2UgPiAvc3lzL2RldmljZXMvc3lzdGVtL2NwdS9j
cHUxNC9jcHVmcmVxL3NjYWxpbmdfZ292ZXJub3IKZWNobyBwZXJmb3JtYW5jZSA+IC9zeXMv
ZGV2aWNlcy9zeXN0ZW0vY3B1L2NwdTE1L2NwdWZyZXEvc2NhbGluZ19nb3Zlcm5vcgplY2hv
IHBlcmZvcm1hbmNlID4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1Mi9jcHVmcmVxL3Nj
YWxpbmdfZ292ZXJub3IKZWNobyBwZXJmb3JtYW5jZSA+IC9zeXMvZGV2aWNlcy9zeXN0ZW0v
Y3B1L2NwdTMvY3B1ZnJlcS9zY2FsaW5nX2dvdmVybm9yCmVjaG8gcGVyZm9ybWFuY2UgPiAv
c3lzL2RldmljZXMvc3lzdGVtL2NwdS9jcHU0L2NwdWZyZXEvc2NhbGluZ19nb3Zlcm5vcgpl
Y2hvIHBlcmZvcm1hbmNlID4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1NS9jcHVmcmVx
L3NjYWxpbmdfZ292ZXJub3IKZWNobyBwZXJmb3JtYW5jZSA+IC9zeXMvZGV2aWNlcy9zeXN0
ZW0vY3B1L2NwdTYvY3B1ZnJlcS9zY2FsaW5nX2dvdmVybm9yCmVjaG8gcGVyZm9ybWFuY2Ug
PiAvc3lzL2RldmljZXMvc3lzdGVtL2NwdS9jcHU3L2NwdWZyZXEvc2NhbGluZ19nb3Zlcm5v
cgplY2hvIHBlcmZvcm1hbmNlID4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1OC9jcHVm
cmVxL3NjYWxpbmdfZ292ZXJub3IKZWNobyBwZXJmb3JtYW5jZSA+IC9zeXMvZGV2aWNlcy9z
eXN0ZW0vY3B1L2NwdTkvY3B1ZnJlcS9zY2FsaW5nX2dvdmVybm9yCm1rZnMgLXQgZXh0NCAt
cSAvZGV2L3NkYTIKZWNobyAxID4gL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy9ldmVudHMv
d3JpdGViYWNrL2JhbGFuY2VfZGlydHlfcGFnZXMvZW5hYmxlCmVjaG8gMSA+IC9zeXMva2Vy
bmVsL2RlYnVnL3RyYWNpbmcvZXZlbnRzL3dyaXRlYmFjay9iZGlfZGlydHlfcmF0ZWxpbWl0
L2VuYWJsZQplY2hvIDEgPiAvc3lzL2tlcm5lbC9kZWJ1Zy90cmFjaW5nL2V2ZW50cy93cml0
ZWJhY2svZ2xvYmFsX2RpcnR5X3N0YXRlL2VuYWJsZQplY2hvIDEgPiAvc3lzL2tlcm5lbC9k
ZWJ1Zy90cmFjaW5nL2V2ZW50cy93cml0ZWJhY2svd3JpdGViYWNrX3NpbmdsZV9pbm9kZS9l
bmFibGUKbW91bnQgLXQgZXh0NCAvZGV2L3NkYTIgL2ZzL3NkYTIKZGQgYnM9NGsgaWY9L2Rl
di96ZXJvIG9mPS9mcy9zZGEyL3plcm8tMSBzdGF0dXM9bm9uZSAmCmRkIGJzPTRrIGlmPS9k
ZXYvemVybyBvZj0vZnMvc2RhMi96ZXJvLTIgc3RhdHVzPW5vbmUgJgpzbGVlcCA2MDAKa2ls
bGFsbCAtOSBkZAoKCg==
--------------030205000807050707040800--
