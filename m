Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3HBWPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:15:48 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46814 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab3HBWPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:15:44 -0400
From: Zach Levis <zml@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, oleg@redhat.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dan.carpenter@oracle.com,
        Zach Levis <zml@linux.vnet.ibm.com>
Subject: [PATCH v2 0/3] fs/binfmts: Improve handling of loops 
Date: Fri,  2 Aug 2013 15:12:12 -0700
Message-Id: <1375481535-20034-1-git-send-email-zml@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
In-Reply-To: 1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080222-7182-0000-0000-000007F463F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This v2 is based off Oleg's changes from "exec: more cleanups" and "exec: minor cleanups + minor fix"

It incorporates Oleg and Andrew's suggestions and takes care of the issue from Dan's patch "fs/binfmts: double unlock in search_binary_handler()"

