Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab3ATQzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 11:55:23 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33457 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab3ATQzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 11:55:22 -0500
Message-ID: <1358700917.2406.93.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, pjones@redhat.com, dhowells@redhat.com,
        jwboyer@redhat.com
Date: Sun, 20 Jan 2013 11:55:17 -0500
In-Reply-To: <adaba402-2f13-4e0b-ac06-143adaf6101b@email.android.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	 <1358437021.2689.52.camel@falcor1> <20130117155154.GC12165@redhat.com>
	 <1358440365.2689.72.camel@falcor1>
	 <adaba402-2f13-4e0b-ac06-143adaf6101b@email.android.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012016-7182-0000-0000-000004927CAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-20 at 08:17 -0800, H. Peter Anvin wrote:
> You then get into issues like: do we have to ban prelink as a result?

Once you change a file, the original signature shouldn't match.  If you
really trust prelink, then make prelink a trusted application that can
resign the modified file.  How to create/store/use private keys on the
target system is a separate issue.

thanks,

Mimi



