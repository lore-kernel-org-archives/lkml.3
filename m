Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936920Ab3DKD5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:57:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:35543 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935222Ab3DKD5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:57:19 -0400
X-Spam-Score: -100.8
Message-ID: <5166347C.6020200@asianux.com>
Date: Thu, 11 Apr 2013 11:56:44 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
References: <51653645.90401@asianux.com> <407910335.12018469.1365624535873.JavaMail.root@redhat.com>
In-Reply-To: <407910335.12018469.1365624535873.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月11日 04:08, Eric Paris wrote:
> We only allow one filter key per rule.  So we should never be able to get into this situation.  See audit_data_to_entry()

  really it is, thanks.

  :-)

-- 
Chen Gang

Asianux Corporation
