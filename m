Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaG3Q0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:26:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37426 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbaG3Q0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:26:44 -0400
Message-ID: <53D91CBC.1000901@canonical.com>
Date: Wed, 30 Jul 2014 12:26:36 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: david@fromorbit.com, xfs@oss.sgi.com,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH][v3.2.y] xfs: really fix the cursor leak in xfs_alloc_ag_vextent_near
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
    
Please consider including mainline commit
e3a746f5aab71f2dd0a83116772922fb37ae29d6 in the next v3.2.y release.  It
was included in the mainline tree as of v3.5.  It has been tested and
confirmed
to resolve http://bugs.launchpad.net/bugs/1327360 .


commit e3a746f5aab71f2dd0a83116772922fb37ae29d6
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Jul 12 07:40:42 2012 +1000

    xfs: really fix the cursor leak in xfs_alloc_ag_vextent_near


Sincerely,
Joseph Salisbury

