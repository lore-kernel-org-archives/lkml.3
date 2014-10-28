Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaJ1WL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:11:58 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63797 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJ1WL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:11:56 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] reduce verifier memory consumption and add tests
Date: Tue, 28 Oct 2014 15:11:40 -0700
Message-Id: <1414534303-9906-1-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small set of cleanups:
 - reduce verifier memory consumption
 - add verifier test to check register state propagation and state equivalence
 - add JIT test reduced from recent nmap triggered crash

Alexei Starovoitov (3):
  bpf: reduce verifier memory consumption
  samples: bpf: add a verifier test and summary line
  test: bpf: add a testcase reduced from nmap

 kernel/bpf/verifier.c       |  101 ++++++++++++++++++++++++-------------------
 lib/test_bpf.c              |   43 ++++++++++++++++++
 samples/bpf/test_verifier.c |   46 +++++++++++++++++++-
 3 files changed, 145 insertions(+), 45 deletions(-)

-- 
1.7.9.5

