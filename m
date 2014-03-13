Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaCMPw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:52:56 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:60860 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaCMPwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:52:55 -0400
MIME-Version: 1.0
In-Reply-To: <CALkWK0npg=XSnB0jCN9E60MoQNskhrcuV7YYZF_4-bCKnKWLcg@mail.gmail.com>
References: <1393896396-10427-1-git-send-email-artagnon@gmail.com>
 <20140305095155.GA1835@krava.brq.redhat.com> <CALkWK0npg=XSnB0jCN9E60MoQNskhrcuV7YYZF_4-bCKnKWLcg@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 13 Mar 2014 11:52:12 -0400
Message-ID: <CALkWK0=OigDKDZqpr5nm12jypH=Qpk2Z6JphpnVrCSZm038gOg@mail.gmail.com>
Subject: Re: [PATCH] perf kvm: introduce --list-cmds for use by scripts
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra wrote:
> Jiri Olsa wrote:
>> On Mon, Mar 03, 2014 at 08:26:36PM -0500, Ramkumar Ramachandra wrote:
>>> Introduce
>>>
>>>   $ perf kvm --list-cmds
>>>
>>> to dump a raw list of commands for use by the completion script. In
>>> order to do this, introduce parse_options_subcommand() for handling
>>> subcommands as a special case in the parse-options machinery.

Jiri? How do we proceed with this?
