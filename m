Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaDOVy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 17:54:26 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58449 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaDOVyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 17:54:24 -0400
MIME-Version: 1.0
In-Reply-To: <1397596546-10153-2-git-send-email-vgoyal@redhat.com>
References: <1397596546-10153-1-git-send-email-vgoyal@redhat.com> <1397596546-10153-2-git-send-email-vgoyal@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 15 Apr 2014 14:54:02 -0700
Message-ID: <CALCETrV7ZwWtCJQ2uF3WmctTj0qBkh2MRQS4uy9vPhP0zKPYrQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: Implement SO_PEERCGROUP
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Simo Sorce <ssorce@redhat.com>, lpoetter@redhat.com, kay@redhat.com,
        dwalsh@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 2:15 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Implement SO_PEERCGROUP along the lines of SO_PEERCRED. This returns the
> cgroup of first mounted hierarchy of the task. For the case of client,
> it represents the cgroup of client at the time of opening the connection.
> After that client cgroup might change.
>
> This works only for unix stream sockets.

I still don't understand why this is useful when SCM_CGROUP exists.

--Andy
