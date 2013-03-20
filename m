Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab3CTFIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 01:08:05 -0400
Received: from tundra.namei.org ([65.99.196.166]:47126 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab3CTFID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 01:08:03 -0400
Date: Wed, 20 Mar 2013 16:07:58 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        dmitry.kasatkin@intel.com, akpm@linux-foundation.org,
        ebiederm@xmission.com
Subject: Re: [PATCH 3/4] capability: Create a new capability CAP_SIGNED
In-Reply-To: <51438EDB.3050300@schaufler-ca.com>
Message-ID: <alpine.LRH.2.02.1303201603380.9518@tundra.namei.org>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com> <1363379758-10071-4-git-send-email-vgoyal@redhat.com> <51438EDB.3050300@schaufler-ca.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013, Casey Schaufler wrote:

> Capabilities aren't just random attribute bits. They
> indicate that a task has permission to violate a
> system policy (e.g. change the mode bits of a file
> the user doesn't own).

Casey's right here, as well he should be.


-- 
James Morris
<jmorris@namei.org>
