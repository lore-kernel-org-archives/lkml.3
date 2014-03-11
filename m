Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaCKT7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:59:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbaCKT7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:59:10 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com
Subject: [PATCH 0/2] kernel AUDIT_LOGIN event is missing subject label
Date: Tue, 11 Mar 2014 15:58:21 -0400
Message-Id: <cover.1394567663.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was fixed in RHEL6 as BZ 670328, but never upstreamed.

Eric Paris (1):
  audit: include subject in login records

Richard Guy Briggs (1):
  audit: remove superfluous new- prefix in AUDIT_LOGIN messages

 kernel/auditsc.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

