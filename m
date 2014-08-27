Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936097AbaH0Wdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:33:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31875 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbaH0Wdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:33:49 -0400
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [V1 PATCH 0/2] Linux PVH: set EFER bits..
Date: Wed, 27 Aug 2014 15:33:33 -0700
Message-Id: <1409178815-2026-1-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with comments fixed up. Please note, these are no longer
AMD only, but address existing broken boot and broken NX on intel.

thanks
mukesh

