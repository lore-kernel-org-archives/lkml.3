Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaHUCRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:17:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24462 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaHUCQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:16:59 -0400
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [V0 PATCH 0/2] AMD PVH domU support
Date: Wed, 20 Aug 2014 19:16:38 -0700
Message-Id: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's first stab at AMD PVH domU support. Pretty much the only thing
needed is EFER bits set. Please review.

thanks,
Mukesh


